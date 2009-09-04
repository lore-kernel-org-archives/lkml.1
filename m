Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZIDAcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZIDAcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 20:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbZIDAcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 20:32:46 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:46766 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbZIDAcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 20:32:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=HPq6sFX5vpYgd89N6HW/Wbsz2hUgQSzfGKLwXP+Ea8+iIf6gBxYdbE4MJkcLjrCRGh
         sU/KVw2jXBtUicETVUoSETqdIprFU9FNPNgD/2oCe15IBP1Wr4hHMIhwD1x0HyGXOSMK
         F8XV1lC5iIsZvhTUgpM18iCD5RMNeMObQ9Ecw=
MIME-Version: 1.0
In-Reply-To: <200909031809.58107.tfjellstrom@shaw.ca>
References: <200909031809.58107.tfjellstrom@shaw.ca>
From: David Rees <drees76@gmail.com>
Date: Thu, 3 Sep 2009 17:32:28 -0700
Message-ID: <72dbd3150909031732p76275c83hc43ca30601be3e53@mail.gmail.com>
Subject: Re: mvsas issues
To: tfjellstrom@shaw.ca
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 5:09 PM, Thomas Fjellstrom<tfjellstrom@shaw.ca> wrote:
> I just got a Marvell SAS card, And I've been trying to copy one set of disks
> over to another before one of the drives dies for good...

Have you tried using one of the rescue oriented versions of dd to make
a copy of the failing disk?  Then copy the image to a good disk and
recreate your array (do it in read-only mode!) and see what you can
recover.

http://en.wikipedia.org/wiki/Dd_%28Unix%29#Recovery-oriented_variants_of_dd

-Dave
