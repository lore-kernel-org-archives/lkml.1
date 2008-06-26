Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbYFZORh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbYFZORh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 10:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbYFZOR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 10:17:26 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:31029 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbYFZORZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 10:17:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:sender;
        b=b7vnr9yTc9nKdrr1xdnGnDTW6xD+bFRA82xK4Duf0xYfjtw1rNMEJsFUG/0t2rY0xO
         HYnJ4nKnAiv18QPPRpRB9ZVYbV0HnhTILKB5ngc7hhGBRAaLJz73fargcU45/Homz6FQ
         +SBtJ5Mq+R3vlcJbrIx9xP5J7IFBAF3pWOhBc=
To: monstr@seznam.cz
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, Michal Simek <monstr@monstr.eu>,
       vapier.adi@gmail.com, arnd@arndb.de, matthew@wil.cx,
       microblaze-uclinux@itee.uq.edu.au, drepper@redhat.com,
       linuxppc-dev@ozlabs.org, will.newton@gmail.com, hpa@zytor.com,
       John.Linn@xilinx.com, john.williams@petalogix.com
Subject: Re: [PATCH 60/60] microblaze_v4: Enable drivers for Microblaze
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
	<1214483429-32360-42-git-send-email-monstr@seznam.cz>
	<1214483429-32360-43-git-send-email-monstr@seznam.cz>
	<1214483429-32360-44-git-send-email-monstr@seznam.cz>
	<1214483429-32360-45-git-send-email-monstr@seznam.cz>
	<1214483429-32360-46-git-send-email-monstr@seznam.cz>
	<1214483429-32360-47-git-send-email-monstr@seznam.cz>
	<1214483429-32360-48-git-send-email-monstr@seznam.cz>
	<1214483429-32360-49-git-send-email-monstr@seznam.cz>
	<1214483429-32360-50-git-send-email-monstr@seznam.cz>
	<1214483429-32360-51-git-send-email-monstr@seznam.cz>
	<1214483429-32360-52-git-send-email-monstr@seznam.cz>
	<1214483429-32360-53-git-send-email-monstr@seznam.cz>
	<1214483429-32360-54-git-send-email-monstr@seznam.cz>
	<1214483429-32360-55-git-send-email-monstr@seznam.cz>
	<1214483429-32360-56-git-send-email-monstr@seznam.cz>
	<1214483429-32360-57-git-send-email-monstr@seznam.cz>
	<1214483429-32360-58-git-send-email-monstr@seznam.cz>
	<1214483429-32360-59-git-send-email-monstr@seznam.cz>
	<1214483429-32360-60-git-send-email-monstr@seznam.cz>
	<1214483429-32360-61-git-send-email-monstr@seznam.cz>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Thu, 26 Jun 2008 16:16:39 +0200
In-Reply-To: <1214483429-32360-61-git-send-email-monstr@seznam.cz> (monstr@seznam.cz's message of "Thu\, 26 Jun 2008 14\:30\:29 +0200")
Message-ID: <87d4m4i8mw.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "monstr" == monstr  <monstr@seznam.cz> writes:

 monstr> From: Michal Simek <monstr@monstr.eu>
 monstr> Signed-off-by: Michal Simek <monstr@monstr.eu>

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

 monstr>  config SERIAL_UARTLITE
 monstr>  	tristate "Xilinx uartlite serial port support"
 monstr> -	depends on PPC32
 monstr> +	depends on PPC32 || MICROBLAZE
 monstr>  	select SERIAL_CORE
 monstr>  	help

-- 
Bye, Peter Korsgaard
