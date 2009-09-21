Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbZIUXhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbZIUXhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 19:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbZIUXhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 19:37:15 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:4718 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385AbZIUXhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 19:37:14 -0400
From: James Cloos <cloos@jhcloos.com>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: Poor desktop responsiveness with background I/O-operations
In-Reply-To: <4AB8027A.1040600@arcor.de> (Nikos Chantziaras's message of "Tue,
	22 Sep 2009 01:47:22 +0300")
References: <4AB59CBB.8090907@datenparkplatz.de>
	<20090920080728.73bfe2a1@infradead.org>
	<4AB5ECD0.7010903@datenparkplatz.de>
	<1253475521.9224.43.camel@marge.simson.net>
	<4AB6C73C.1030004@gmail.com>
	<1253507034.23414.90.camel@marge.simson.net>
	<4AB72FDC.5090403@datenparkplatz.de>
	<1253520364.25640.57.camel@marge.simson.net>
	<m3tyyw6pvz.fsf@lugabout.jhcloos.org> <4AB8027A.1040600@arcor.de>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Mon, 21 Sep 2009 19:34:50 -0400
Message-ID: <m38wg73m8d.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Nikos" == Nikos Chantziaras <realnc@arcor.de> writes:

Nikos> On 09/21/2009 10:47 PM, James Cloos wrote:
>> is a great way to trigger the problem.  As is using Gentoo's portage
>> to install/upgrade anything.

Nikos> Fortunately, this is completely (at least here) solved by putting
Nikos> those in make.conf:

Nikos> PORTAGE_NICENESS=19
Nikos> PORTAGE_IONICE_COMMAND="ionice -c 3 -p \${PID}"

I had NICENESS set, but had never noticed that PORTAGE_IONICE_COMMAND
was available.  I'll give that a test.  Thanks.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
