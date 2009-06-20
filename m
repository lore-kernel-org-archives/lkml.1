Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbZFTO4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbZFTO4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 10:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZFTO4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 10:56:09 -0400
Received: from netrider.rowland.org ([192.131.102.5]:47776 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753142AbZFTO4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 10:56:06 -0400
Date: Sat, 20 Jun 2009 10:56:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ravish Tayal <ravish.tayal@gmail.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: generic_make_request fucntion for scsi_disk
In-Reply-To: <e42309110906200746u441b82acvec4e3e513253af0@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0906201052090.13441-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You should use Reply-To-All so that other people reading the mailing 
list will be able to follow and contribute to the thread.

On Sat, 20 Jun 2009, Ravish Tayal wrote:

> Thanks Alan,
> 
> I am actually trying to profile the time taken by each layer to complete the
> disk write opertaion as sys_write to queue_command invokation veries alot.

Of course it varies.  The kernel buffers disk writes, shuffles them 
around, and then carries them out when it wants to.  As James has 
pointed out, your write(2) system calls don't directly cause any I/O to 
take place.

Alan Stern


