Return-Path: <linux-kernel-owner+w=401wt.eu-S1762621AbYFFTf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762621AbYFFTf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 15:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbYFFTft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 15:35:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755537AbYFFTfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 15:35:48 -0400
Date: Fri, 6 Jun 2008 12:35:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: greg@kroah.com, justinmattock@gmail.com, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] isight_firmware: Avoid crash on loading invalid
 firmware
Message-Id: <20080606123511.38ffbdde.akpm@linux-foundation.org>
In-Reply-To: <20080606192135.GA16727@srcf.ucam.org>
References: <dd18b0c30806041213x45b7efdfo42de9b214a7ce9df@mail.gmail.com>
	<20080606002601.a0f6c47c.akpm@linux-foundation.org>
	<dd18b0c30806060137j7edc751se364ff21cfc8911b@mail.gmail.com>
	<20080606121136.GA9087@srcf.ucam.org>
	<20080606110711.a9a6a4f6.akpm@linux-foundation.org>
	<dd18b0c30806061110qd3100b4p1ee9f8ef493a56c6@mail.gmail.com>
	<dd18b0c30806061138h69c87d6am898a4eb409d379e1@mail.gmail.com>
	<20080606185548.GB8576@kroah.com>
	<20080606192135.GA16727@srcf.ucam.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 20:21:35 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Different tools generate slightly different formats of the isight 
> firmware. Ensure that the firmware buffer is not overrun, while still 
> ensuring that the correct amount of data is written if trailing data is 
> prseent.

It would have been nice to have mentioned this Justin Maddock fellow
in the changelog.

