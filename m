Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbZGPGho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbZGPGho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 02:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbZGPGhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 02:37:43 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:47612 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbZGPGhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 02:37:42 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jul 2009 02:37:42 EDT
To: Jeff Garzik <jeff@garzik.org>
Cc: git@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] GIT 1.6.4.rc1
References: <7vmy75bg2f.fsf@alter.siamese.dyndns.org>
 <4A5EA598.5050801@garzik.org>
From: Junio C Hamano <gitster@pobox.com>
Date: Wed, 15 Jul 2009 23:31:04 -0700
In-Reply-To: <4A5EA598.5050801@garzik.org> (Jeff Garzik's message of "Wed\,
 15 Jul 2009 23\:59\:20 -0400")
Message-ID: <7v3a8xb0lz.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 4042DA2E-71D2-11DE-9740-9AE02FB70C38-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> Is there some sort of guide to the new best practices for handling
> trees such as git.kernel.org, where one pushes into "foo.git"
> directly, and there is no checked-out source code at all?

I think old repositories will be helped if you add

	[core]
        	bare

to their foo.git/config files.
