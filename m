Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbZDXVOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbZDXVOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 17:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbZDXVOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 17:14:14 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:44605 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbZDXVON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 17:14:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=hZAZ+Oa6IPw5FC7aWl6ik/+qZ5IC/fuWFv6nlWhjE8/Wr0as4uXVmvXi8QxRD8mEO4
         /wbvorSrcJ4LtGpET7ePH/7iJydmrzmsaF4+fr/keDdZZuLAjHbUcBGNY0qBLfTcYFD6
         jBDVP8RUY0njc5ZKG6cp/J9uGvCg0YwwODdN0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Roland McGrath <roland@redhat.com>
Subject: Re: SIGSTOP && ptrace (Was: ptrace(PTRACE_SYSCALL/CONT/DETACH, ..., SIGSTOP) does not work)
Date: Fri, 24 Apr 2009 23:15:05 +0200
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Jan Kratochvil <jan.kratochvil@redhat.com>
References: <1158166a0904230515h333a78c9uf49931824c1dfe72@mail.gmail.com> <20090423142627.GA31572@redhat.com> <20090424062354.A1F88FC3C7@magilla.sf.frob.com>
In-Reply-To: <20090424062354.A1F88FC3C7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904242315.05422.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 April 2009 08:23, Roland McGrath wrote:
> > Perhaps, you should ask how strace can distinguish between "SIGSTOP
> > recieved" and "group-stop completed". I am not 100% sure, but at first
> > glance this looks possible.
> 
> It is, but it's easier than the hack you suggest.  PTRACE_GETSIGINFO only
> works for a ptrace stop, not a job control stop.  If wait reported SIGSTOP,
> PTRACE_GETSIGINFO will fail with EINVAL for a job control stop but will
> succeed for a ptrace stop.

I already tested it and it works.
--
vda
