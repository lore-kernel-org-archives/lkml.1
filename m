Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbYJHPh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbYJHPh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 11:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYJHPhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 11:37:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:7512 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYJHPht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 11:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f3V0Au7VBmvtop5+jVBW9J43rHRNwvNXpsWm3Sr+9KWvXCuTashI/m/rlWt774+H4H
         zgGODRWiw5eknW85VUB7cHnyFEUqE/rmzUcA5BzmPAd+4Mp3Gv1RUdPekCDR4unSfABv
         CQ4PC7BOwL7IzUz5fCvzpGe69cnNbkJfsiTiA=
Date: Wed, 8 Oct 2008 19:40:28 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Robin H. Johnson" <robbat2@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel/acct.c and testing for accounting still running?
Message-ID: <20081008154028.GA2520@x200.localdomain>
References: <20081007235331.GT9967@curie-int.orbis-terrarum.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007235331.GT9967@curie-int.orbis-terrarum.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 04:53:31PM -0700, Robin H. Johnson wrote:
> I ran into a bit of flapping with my init.d acct lately, and in tracing
> why, I noticed that there seems to be absolutely no way that the kernel
> exposes to show that it's running any accounting.
> 
> Could we expose acct_list in sysfs or procfs, as uid:0, gid:0, perms
> 0600?

What other OS do in this respect?
