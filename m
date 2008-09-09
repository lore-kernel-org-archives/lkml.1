Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbYIIPNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbYIIPNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbYIIPNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:13:44 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:47591 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbYIIPNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:13:44 -0400
From: Junio C Hamano <gitster@pobox.com>
To: Michael J Gruber <michaeljgruber+gmane@fastmail.fm>
Cc: unlisted-recipients:"; (no To-header on input)
	Bert Wesarg" <bert.wesarg@googlemail.com>,
       "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>,
       Git Mailing List <git@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       guilt@lists.josefsipek.net, Brandon Philips <brandon@ifup.org>
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
	Cc:	unlisted-recipients:; (no To-header on input)Bert Wesarg <bert.wesarg@googlemail.com>
								     ^-missing end of address
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
	Cc:	unlisted-recipients:; (no To-header on input)Bert Wesarg <bert.wesarg@googlemail.com>
								     ^-missing end of address
Subject: Re: [ANNOUNCE] Guilt v0.31
References: <20080908135244.GB27550@josefsipek.net>
 <36ca99e90809081133s58e3d32h8b85804f5bb76902@mail.gmail.com>
 <20080908184322.GE27550@josefsipek.net>
 <36ca99e90809081150v4ad6e7a0n72b5cca39e02b1bc@mail.gmail.com>
 <7vmyiifnwa.fsf@gitster.siamese.dyndns.org> <48C64B8B.5000606@fastmail.fm>
 <48C673CF.2000107@fastmail.fm>
Date: Tue, 09 Sep 2008 08:13:20 -0700
In-Reply-To: <48C673CF.2000107@fastmail.fm> (Michael J. Gruber's message of
 "Tue, 09 Sep 2008 15:02:07 +0200")
Message-ID: <7vd4jd8i9b.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: E3113330-7E81-11DD-A7DC-D0CFFE4BC1C1-77302942!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael J Gruber <michaeljgruber+gmane@fastmail.fm> writes:

> I would go about renaming quick-install-doc to quick-install-man, introducing quick-install-html doing the analogous using the "html" branch and quick-install-doc doing both, which would be more in line with the install-doc target.
>
> Are there any objections to renaming quick-install-doc to quick-install-man?

What does it improve?

IOW, can't you do what you want to do (I am assuming that what you want to
do is to be able to copy out the pregenerated contents from convenience
branches) without such a rename?

If you rename the target, I am reasonably sure you would break somebody's
build procedure.  It is a separate topic if there are large number of such
somebody, or just a limited few.
