Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbZGHHB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbZGHHB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 03:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbZGHHBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 03:01:50 -0400
Received: from mail-px0-f181.google.com ([209.85.216.181]:58933 "EHLO
	mail-px0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbZGHHBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 03:01:49 -0400
X-Greylist: delayed 639 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jul 2009 03:01:49 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DiGUPJyC0Dg5VLIQb7CPnzASENids5b47BKuxbzPtTvEABLU3oR3i+n8BS9t5H1viU
         4HHNZqEBsGAJhqFSxV4g4wVe6Bl3o6UUXXjzlmUseIP7iU1wf+TC6FWmamJmwzhw9MZB
         +zG2giPDfse/Vyt2VoGlHbOGWCUGMsWNGWYY8=
Date: Tue, 7 Jul 2009 23:54:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-input@vger.kernel.org, maciej.rutecki@gmail.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Input: mark serio and i8042 as suspended when
	hibernating too.
Message-ID: <20090708065435.GF3309@dtor-d630.eng.vmware.com>
References: <1246760019-4120-1-git-send-email-cascardo@holoscopio.com> <200907070040.43299.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907070040.43299.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 12:40:42AM +0200, Rafael J. Wysocki wrote:
> On Sunday 05 July 2009, Thadeu Lima de Souza Cascardo wrote:
> > serio ports are not being restarted any longer because resume operations
> > after hibernate do nothing, since the device has not been marked as
> > suspended. This happens because suspend is only considering the SUSPEND
> > event but not the FREEZE event.
> > 
> > Note that this driver has still to migrate to dev_pm_ops, but this fixes
> > this particular bug now.
> 
> Hmm, this looks like a fix for:
> http://bugzilla.kernel.org/show_bug.cgi?id=13643
> 
> Any objections to merging it through the suspend tree?
> 

Oops, just applied it to mine before reading your mail... I hope Linus
will pick my pull request soon so it won't matter thoough.

-- 
Dmitry
