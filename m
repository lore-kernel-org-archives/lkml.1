Return-Path: <linux-kernel-owner+w=401wt.eu-S932259AbYCFS7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbYCFS7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbYCFS7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:59:36 -0500
Received: from lain.randombit.net ([66.179.181.40]:37427 "EHLO
	mail.randombit.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYCFS7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:59:35 -0500
X-Greylist: delayed 1671 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2008 13:59:35 EST
Date: Thu, 6 Mar 2008 13:31:46 -0500
From: Jack Lloyd <lloyd@randombit.net>
To: gcc@gcc.gnu.org, linux-kernel@vger.kernel.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction    flag
Message-ID: <20080306183146.GL27983@randombit.net>
Mail-Followup-To: gcc@gcc.gnu.org, linux-kernel@vger.kernel.org
References: <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com> <47CF3F09.4080606@zytor.com> <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com> <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org> <47CFF9A3.30309@gnu.org> <20080306141221.GC5236@dspnet.fr.eu.org> <20080306175841.GI17267@synopsys.com> <20080306181029.GA42904@dspnet.fr.eu.org> <47D03440.6090503@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D03440.6090503@gnu.org>
X-PGP-Fingerprint: 3F69 2E64 6D92 3BBE E7AE 9258 5C0F 96E8 4EC1 6D6B
X-PGP-Key: http://www.randombit.net/pgpkey.html
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 07:13:20PM +0100, Paolo Bonzini wrote:
> A process can send a signal via kill.  IOW, a malicious process can 
> *control when the process would be interrupted* in order to get it into 
> the signal handler with DF=1.

If the malicious process can send a signal to another process, it
could also ptrace() it. Which is more useful, if you wanted to be
malicious?

Jack
