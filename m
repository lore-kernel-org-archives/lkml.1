Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbZEXRjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbZEXRjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 13:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZEXRjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 13:39:33 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:48065 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753655AbZEXRjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 13:39:33 -0400
Date: Sun, 24 May 2009 19:39:33 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: tytso@thunk.org, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org
Subject: Re: zero out blocks of freed user data for operation a virtual
	machine environment
Message-ID: <20090524173933.GD24753@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Arjan van de Ven <arjan@infradead.org>, tytso@thunk.org,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de> <20090524101551.57b706e9@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090524101551.57b706e9@infradead.org>
User-Agent: Mutt/1.5.15 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > tunable feature that zeroes our free data

> wouldn't it be better if the VM's would just support the TRIM command?

the resources available to me indicate that the TRIM command is a not
yet standarized command targeted at SSD disks to indicate free disk
space. Does ext3/4 trigger a block device layer call that could result
in a TRIM command?

        Thomas
