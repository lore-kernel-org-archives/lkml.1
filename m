Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbXGGBp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbXGGBp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 21:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXGGBpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 21:45:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:9852 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbXGGBps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 21:45:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Do8fwxSCIeTr/A0CSP1A68ACMaSfF4EaS8upBsqwIW+1f3G6I0dCP87kfaF0jeL1S5o7Bnr4uHcXpCl3WWbvMs/Ace2MkfXrBxttYygrGwps6ulXesQeVa15s8r2uT3GnMF8VX0MgXnE4vfH0Zv15GGd3SaakkUXz1E/UauJLp8=
Message-ID: <787b0d920707061845o6cf314dakf45c839c4fc0e600@mail.gmail.com>
Date: Fri, 6 Jul 2007 21:45:47 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: partially mounted cifs filesystem
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I had one share mounted, from XP to Linux, and wanted another.
At first I had an incorrect setting on the XP box, almost
certainly related to permissions. The mount failed of course.
Running "mount" showed that the filesystem was not mounted,
but apparently it didn't remain fully unmounted either.
There was also nothing under the mount point, and the "ls -l"
data (directory size and link count) looked like ext3.

I changed settings on the XP box numerous times. After many
frustrating attempts, I ran "umount" on the mount point and
then successfully mounted the filesystem.

I'll guess that the kernel returned an error for my early
attempts at mounting, but left open a CIFS connection.

I suppose the cifs error handling is buggy.
