Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbXKKKWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbXKKKWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 05:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbXKKKWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 05:22:41 -0500
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:11206 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437AbXKKKWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 05:22:41 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: Bind mount bug?
Date: Sun, 11 Nov 2007 11:22:36 +0100
User-Agent: KMail/1.9.7
References: <200711111106.53494.elendil@planet.nl>
In-Reply-To: <200711111106.53494.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711111122.36573.elendil@planet.nl>
X-OriginalArrivalTime: 11 Nov 2007 10:22:39.0059 (UTC) FILETIME=[C9218230:01C8244C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 November 2007, Frans Pop wrote:
> I'd expected the last command to list "foo", but it shows an empty dir.
> Shouldn't it also show the original contents of test (as they were before
> the first bind mount)?

The problem is of course also that any changes made into /test/test will get 
lost into thin space:

# touch test/test/baz
# ls bindtest/test
foo
# umount test
# ls test
foo
#
