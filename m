Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZGMXGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZGMXGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 19:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbZGMXGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 19:06:54 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:42317 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbZGMXGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 19:06:53 -0400
Subject: Re: Floppy constantly accessed in 2.6.31-rc2
From: Paul Bolle <pebolle@tiscali.nl>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <h3ehgd$mti$1@ger.gmane.org>
References: <h3ehgd$mti$1@ger.gmane.org>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 01:06:51 +0200
Message-Id: <1247526411.5220.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.3 (2.27.3-3.kb.1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-12 at 23:44 -0600, Robert Hancock wrote:
> On 2.6.31-rc2 (actually current git as of today) the floppy drive is 
> constantly being accessed with these messages being reported:
> 
> Platform driver 'floppy' needs updating - please use dev_pm_ops
> Floppy drive(s): fd0 is 1.44M
> FDC 0 is a post-1991 82077
> end_request: I/O error, dev fd0, sector 0
> end_request: I/O error, dev fd0, sector 0
> end_request: I/O error, dev fd0, sector 0
> end_request: I/O error, dev fd0, sector 0
> end_request: I/O error, dev fd0, sector 0
> end_request: I/O error, dev fd0, sector 0
> end_request: I/O error, dev fd0, sector 0
> 
> lsof reports no process with /dev/fd0 open so it is not clear what is 
> causing this activity. It looks like the access starts when I log in to 
> X, but doesn't stop when I log out. I'm guessing HAL or something checks 
> the floppy drive and then the kernel somehow gets stuck in a loop 
> retrying the request..

That does look a bit like
https://bugzilla.redhat.com/show_bug.cgi?id=489083 (and its duplicate
https://bugzilla.redhat.com/show_bug.cgi?id=496586 ).

Regards,


Paul Bolle

