Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbZFEFqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbZFEFqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 01:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbZFEFqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 01:46:48 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:44499 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbZFEFqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 01:46:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i77FdeO6ysY0deXqEIBcZ2ZuKnX3h+jpWXEvQsTm82Py/nrLa70uXqLJkvmww0Z1xV
         o1vJ+qVwIV3MMX0ZX+zldSFfpSIMaQHePub6yUlKZHphOoz4DcqJboelZYyE2Qf0wR2P
         Ym43rCmpRRzFAC8e8q2Ih1KU02qpMk9Fw+KX4=
Date: Fri, 5 Jun 2009 13:49:02 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
	2.6.30-rc8.
Message-ID: <20090605054902.GF7962@cr0.nay.redhat.com>
References: <4A289928.7040508@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A289928.7040508@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 12:03:52PM +0800, Tao Ma wrote:
> Hi list,
>       In 2.6.30-rc8, /proc/kcore in x86_64's size is unreasonable large  
> to be 281474974617600.
> While in a x86 box, it is 931131392 which looks sane.
>
> [root@test8 ~]# ll /proc/kcore
> -r-------- 1 root root 281474974617600 Jun  5 11:15 /proc/kcore
>
> [root@ocfs2-test9 ~]$ ll /proc/kcore
> -r-------- 1 root root 931131392 Jun  5 11:58 /proc/kcore

Hmm, what is your physical RAM size on test8?
/proc/kcore looks fine on my x86_64 box.

>
> I just noticed this when kexec fails in "Can't find kernel text map area  
> from kcore".
>
> Is there something wrong?

It looks like that error message is from userspace?

