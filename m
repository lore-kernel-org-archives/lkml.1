Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZAKPIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZAKPIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 10:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZAKPID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 10:08:03 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:59400 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbZAKPIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 10:08:01 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: git@vger.kernel.org
Subject: Re: current git kernel has strange problems during bisect
Date: Sun, 11 Jan 2009 16:07:59 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
References: <200901111602.53082.borntraeger@de.ibm.com>
In-Reply-To: <200901111602.53082.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901111607.59054.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 11 Januar 2009 schrieb Christian Borntraeger:
> doing a 
> git bisect start
> git bisect good a3a798c
> git bisect bad v2.6.29-rc1
> 
> results in a repository without several files, e.g Makefile!
> git describe also fails.

In fact, retesting with a clean repository shows, that there are only btrfs 
files - nothing else.

Linus did you pull a broken btrfs repository?

Christian
