Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbYCLSED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbYCLSED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYCLSDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:03:54 -0400
Received: from anyanka.rfc1149.net ([81.56.47.149]:45328 "EHLO
	mail2.rfc1149.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYCLSDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:03:53 -0400
To: device-mapper development <dm-devel@redhat.com>
Cc: Christian Kujau <lists@nerdbynature.de>, David Chinner <dgc@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de>
	<20080307224040.GV155259@sgi.com>
	<alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de>
	<20080309213441.GQ155407@sgi.com>
Date: Wed, 12 Mar 2008 19:03:51 +0100
In-Reply-To: <20080309213441.GQ155407@sgi.com> (David Chinner's message of "Mon\, 10 Mar 2008 08\:34\:41 +1100")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Samuel Tardieu <sam@rfc1149.net>
Organization: RFC 1149 (see http://www.rfc1149.net/)
Content-Transfer-Encoding: 8bit
X-WWW: http://www.rfc1149.net/sam
X-Jabber: <sam@rfc1149.net> (see http://www.jabber.org/)
X-OpenPGP-Fingerprint: 79C0 AE3C CEA8 F17B 0EF1  45A5 F133 2241 1B80 ADE6 (see http://www.gnupg.org/)
Message-Id: <2008-03-12-19-03-51+trackit+sam@rfc1149.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "David" == David Chinner <dgc@sgi.com> writes:

>> No, no I/O errors at all. See the kern.log above, I could even do
>> dd(1) from the md1 (dm-crypt on raid1), no errors either.

David> Oh, dm-crypt. Well, I'd definitely start looking there. XFS has
David> a history of exposing dm-crypt bugs, and these hangs appear to
David> be I/O congestion/scheduling related and not XFS. Also, we
David> haven't changed anything related to plug/unplug of block
David> devices in XFS recently, so that also points to some other
David> change as well...

For what it is worth, I notice the same error last week (with a kernel
of the day) on my laptop but was too busy at work to investigate. And
I use ext3... on dm-crypt.

  Sam
-- 
Samuel Tardieu -- sam@rfc1149.net -- http://www.rfc1149.net/

