Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbYJWADl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbYJWADl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 20:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYJWADc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 20:03:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:15988 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbYJWADb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 20:03:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=gw8ZODB3J2v9CkrdRiye6kIrFSbs6SucmzprJDLua1Zlef45ajj9XDHQk1Sqem3S+M
         LaAazyo3bce3Jr0FqW2DUVdLsktTXnYdQwt/1J1bE/EvLTaZjrUjOPgPZrlhmH1918cy
         xcELHFXlk5OPUV0kI+Sw1+z8TxULRMviUuq2s=
Message-ID: <86802c440810221703y6d5a3be3ge260014b25be1345@mail.gmail.com>
Date: Wed, 22 Oct 2008 17:03:30 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: Hang early in boot with 2.6.27-git
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <adaej28urfi.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <adaej28urfi.fsf@cisco.com>
X-Google-Sender-Auth: 443121ed30965a94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 4:43 PM, Roland Dreier <rdreier@cisco.com> wrote:
> Latest git (head 2515ddc6db8eb49a79f0fe5e67ff09ac7c81eab4) hangs early
> in boot.  One clue is that if I let it sit there for ~30 minutes, I get
> a message about the tsc being unstable... the last messages are:
>
> [    2.255064] NET: Registered protocol family 2
> [ 1528.453016] Clocksource tsc unstable (delta = 1499794012204 ns)
>
> Any requests for debugging info or suggestions appreciated...
>
> System is a dual-socket quad-core Xeon box.  Full boot log below:
>
> [    2.255064] NET: Registered protocol family 2
> [ 1528.453016] Clocksource tsc unstable (delta = 1499794012204 ns)

http://lkml.org/lkml/2008/10/21/300

YH
