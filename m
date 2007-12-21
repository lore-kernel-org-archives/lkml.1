Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbXLUHSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbXLUHSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 02:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbXLUHSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 02:18:15 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45242 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbXLUHSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 02:18:14 -0500
Date: Fri, 21 Dec 2007 07:17:28 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Srinivas Kommu <kommu@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: driver spin lock and files_lock deadlock question
Message-ID: <20071221071728.GL8181@ftp.linux.org.uk>
References: <476B6448.7090805@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476B6448.7090805@hotmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 10:59:20PM -0800, Srinivas Kommu wrote:

> It seems this kind of a deadlock can happen with any kernel lock, not 
> just files_lock. What's the driver's mistake here? Is it wrong to call 
> remove_proc_entry() while holding another lock? What is the right thing 
> to do?

remove_proc_entry() is a blocking function...
