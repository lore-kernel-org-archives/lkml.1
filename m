Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYIKNdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYIKNdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYIKNc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:32:56 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:36139 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbYIKNcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:32:55 -0400
Date: Thu, 11 Sep 2008 10:33:32 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: "Steven Noonan" <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Semi-repeatable hard lockup on 2.6.27-rc6
Message-ID: <20080911103332.56160ce0@doriath.conectiva>
In-Reply-To: <f488382f0809101426g158a6043l1db8f4e26fdc9c06@mail.gmail.com>
References: <f488382f0809101107h4ce8b912o1093adb44c157005@mail.gmail.com>
	<f488382f0809101426g158a6043l1db8f4e26fdc9c06@mail.gmail.com>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 10 Sep 2008 14:26:12 -0700
"Steven Noonan" <steven@uplinklabs.net> escreveu:

| On Wed, Sep 10, 2008 at 11:07 AM, Steven Noonan <steven@uplinklabs.net> wrote:
| > I've got a hard lockup problem on boot of 2.6.27-rc6. It's sporadic
| > though. Sometimes it locks, sometimes not. Each time it -does- lock
| > up, it gets to 'Waiting for uevents to be processed' and then
| > immediately locks up.
| >
| 
| This problem does -not- occur on 2.6.27-rc6-tip, though. Something's
| screwy in the pristine 2.6.27-rc6 branch.

 Can you describe the machine? Is it SMP?

 The best way would be to run git bisect, but you can also try to
enable all the locking debug features under the Kernel hacking menu.

-- 
Luiz Fernando N. Capitulino
