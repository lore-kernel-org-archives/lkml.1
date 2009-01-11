Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZAKUbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZAKUbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 15:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbZAKUbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 15:31:36 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33331 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbZAKUbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 15:31:36 -0500
Subject: Re: [PATCH 01/11] firewire: cdev: reference-count client instances
From: David Moore <dcm@MIT.EDU>
Reply-To: dcm@acm.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.8de770712ed54822@s5r6.in-berlin.de>
References: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
	 <tkrat.8de770712ed54822@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 12:31:18 -0800
Message-Id: <1231705878.3538.77.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-04 at 16:24 +0100, Stefan Richter wrote:
> The lifetime of struct client instances must be longer than the lifetime
> of any client resource.
> 
> This fixes a possible race between fw_device_op_release and transaction
> completions.  It also prepares for new ioctls for isochronous resource
> management which will involve delayed processing of client resources.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Reviewed-by: David Moore <dcm@acm.org>

