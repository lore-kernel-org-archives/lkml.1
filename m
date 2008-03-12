Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbYCLPK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbYCLPK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 11:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYCLPKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 11:10:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49310 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751739AbYCLPKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 11:10:14 -0400
Date: Wed, 12 Mar 2008 11:10:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Boaz Harrosh <bharrosh@panasas.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       Sven Schnelle <svens@stackframe.org>, <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] isd200: Allocate sense_buffer for hacked up scsi_cmnd
In-Reply-To: <47D7D670.40306@panasas.com>
Message-ID: <Pine.LNX.4.44L0.0803121109210.4595-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Boaz Harrosh wrote:

> Since the separation of sense_buffer from scsi_cmnd, Drivers that hack their
> own struct scsi_cmnd like here isd200, must also take care of their own
> sense_buffer.

Did you run this through checkpatch?

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

