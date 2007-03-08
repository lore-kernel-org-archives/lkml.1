Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbXCHQCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbXCHQCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbXCHQCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:02:24 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44764 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752420AbXCHQCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:02:24 -0500
Date: Thu, 8 Mar 2007 11:02:21 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
In-Reply-To: <200703081405.01087.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0703081101230.4086-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007, Oliver Neukum wrote:

> Hi,
> 
> after a lightning bolt from high above I've been looking into refcounting
> the data structures drivers use to provide the data used to refill sysfs
> buffers. I've come to the following conclusion.
> 
> 1. struct sysfs_buffer must have a struct kref * and probably a destructor
> pointer
> 2. drivers must be able to pass these pointers through an extended
> device_create_file()
> 3. Drivers must use refcounting if they want to use attributes
> 4. read/write/poll must do refcounting
> 
> I am not sure where to store the pointers. struct sysfs_dirent() looks
> like the obvious choice. Comments?

Can you explain the reasoning that led to these conclusions?  And what 
exactly was your lightning bolt?

Alan Stern

