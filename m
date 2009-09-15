Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbZIOXbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbZIOXbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 19:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZIOXbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 19:31:31 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:63950 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZIOXbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 19:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=v4AI67kzpJOMRO62v4EbYubPT/aM784do+kAOuL/U5Qbxx1zOSX4zOMXpNk95GjmtN
         8CRwWv9YkKsCRKl2yb9m6n7ykp59L1Omdi7M//4LJpz5u7I0QhWswRYYjpG9HuE6q6yL
         2OP2TmvjXfwnm0EQb+i1azR6i48gSuIYHOhdw=
MIME-Version: 1.0
Date: Wed, 16 Sep 2009 00:31:33 +0100
Message-ID: <6278d2220909151631s3df216e9w9d6f02c9dceb07bf@mail.gmail.com>
Subject: rebooting with 'pci' method...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My Thinkpad T400 takes ~9 seconds to reset when the default 'keyboard'
reboot vector is invoked, so loading linux is quicker than the reset
part of rebooting!

I find using 'reboot=pci', resetting is instant as expected
('reboot=acpi' hangs). Anyone else in the same situation?

The obvious questions are then, what method does MS Windows use and
what reasons hold reboot=pci back from being the default on x86(-64)
these days?

Thanks,
  Daniel
-- 
Daniel J Blueman
