Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYJUTpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYJUTpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYJUTox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:44:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:31775 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbYJUTow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=n0eSZT+i9i87M7G7uQCIMq8iv5gC3PPlYJuKHYS/+zEsOEnmWSywGfncs2HeuM/39G
         MBOiGK02iyS2G6fpRWTiRm+68XFgpSgTuXyEQUyv53ZjImn3KLYN3zHll8nPBl6gvvzg
         4IEv0I4Bf8nJMuCzbbm0681X3h0oivEo89fCk=
Message-ID: <ba7d8f720810211244q38bff231r5a2f8d46f8eb1abb@mail.gmail.com>
Date: Tue, 21 Oct 2008 15:44:51 -0400
From: "Dan Upton" <upton.dan.linux@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: debugging an oops that kills the system
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <adar669okrk.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ba7d8f720810211014g472c3e83oba511c24e1c2eb97@mail.gmail.com>
	 <adar669okrk.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I'd never come across that but it worked like a charm.  Now on
to the hard part, actually figuring out and fixing the bug ;)

-dan

On Tue, Oct 21, 2008 at 2:39 PM, Roland Dreier <rdreier@cisco.com> wrote:
>  > I'm hoping for some pointers on debugging an oops that ultimately
>  > hangs the system.  I'm doing some scheduler work and I can fairly
>  > reliably duplicate the error on my machine, but the output is too
>  > large for one screen and the system becomes unresponsive after the
>  > crash so I can't scroll the console.  I tried purchasing a  USB->DB9
>  > cable to log to a remote terminal, but so far I haven't had any luck
>  > getting that to work.  Using kdump/kexec doesn't work either--I got
>  > the second kernel to boot successfully using the magic sysrq example
>  > in the documentation, but the second kernel doesn't boot with my
>  > actual crash.  Any other suggestions for what I might do?
>
> If you have two machines (it sounds like you do) and serial console is
> not working for you (could be a setup problem -- do you have a
> "console=" line on your kernel command line?), then netconsole might be
> a good way to debug: Documentation/networking/netconsole.txt
>
>  - R.
>
