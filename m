Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZGYIwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZGYIwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 04:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZGYIwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 04:52:44 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:62543 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbZGYIwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 04:52:43 -0400
To: git@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: warning: "git am --whitespace=fix" broken in 1.6.4-rc2
References: <1248308678-23280-1-git-send-email-szeder@ira.uka.de>
 <7vy6qdupio.fsf@alter.siamese.dyndns.org>
From: Junio C Hamano <gitster@pobox.com>
Date: Sat, 25 Jul 2009 01:52:35 -0700
In-Reply-To: <7vy6qdupio.fsf@alter.siamese.dyndns.org> (Junio C. Hamano's
 message of "Sat\, 25 Jul 2009 01\:37\:35 -0700")
Message-ID: <7vr5w5uoto.fsf_-_@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 843AEE06-78F8-11DE-B533-AEF1826986A2-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am very sorry that I did not spot this earlier, but 1.6.4-rc2 has a
quite serious bug in "git apply --whitespace=fix" (hence "git am" with the
same option) in that it can lose all the added empty lines when it detects
any trailing spaces.  I've sent a fix out already, and am planning to
issue 1.6.4-rc3 this weekend, but in the meantime, please do not use it,
nor any version that contains commit 735c674 (Trailing whitespace and no
newline fix, 2009-07-22).

Unfortunately the commit is included in all recent integration branches
down to 'maint'.  I'll push out the fixes for them soonish.

Sorry for the trouble.
