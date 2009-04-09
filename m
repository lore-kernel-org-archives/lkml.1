Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbZDICiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbZDICiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 22:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbZDICiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 22:38:14 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:57060 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbZDICiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 22:38:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ejV5lovfxSfNNd+ORskZ59ZUT6PsDD0eBVWLJXv4KPP3abTUQSmwmbBuDEtZmz2FoH
         RbZaVrCeVCDM2VMWHvmonjrh8/HyxY5W8SxBJasf9aY4fcQywjXTqnsgT7dnrnu4oJAS
         KPjI0mbvgJzH5jtB/6LWKYzt2JftWeV+v08kk=
MIME-Version: 1.0
In-Reply-To: <dd18b0c30904081919h7cc8333aw8e2693969a0998bf@mail.gmail.com>
References: <dd18b0c30904081919h7cc8333aw8e2693969a0998bf@mail.gmail.com>
Date: Wed, 8 Apr 2009 22:38:11 -0400
Message-ID: <3e8340490904081938r12f20741kec6c4c7068bd4c45@mail.gmail.com>
Subject: Re: BUG kmalloc-2048: Invalid object pointer 0xf656ad80
From: Bryan Donlan <bdonlan@gmail.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 10:19 PM, Justin Mattock <justinmattock@gmail.com> wrote:
> doing a:
> sudo /sbin/rmmod wl
> (generated a bug message)
[snip]
> The kernel is tainted with nvidia, and a broadcom wl.

Would this broadcom wl be the very module you're trying to remove?
What makes you think this isn't a bug in this wl binary module? From
the looks of the backtrace it's dying due to a free of a wild pointer
right in the middle of the wl module - it certainly doesn't look like
it came from some other subsystem...
