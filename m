Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbZGATMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbZGATMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZGATMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:12:17 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2191 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbZGATMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:12:17 -0400
Subject: Re: [PATCH] I/OAT: Convert to PCI_VDEVICE()
From: Joe Perches <joe@perches.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: dan.j.williams@intel.com, maciej.sosnowski@intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <adaprckff1y.fsf@cisco.com>
References: <adaprckff1y.fsf@cisco.com>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 12:12:16 -0700
Message-Id: <1246475536.28915.48.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 11:12 -0700, Roland Dreier wrote:
> Trivial cleanup to make the PCI ID table easier to read.

Should this be done tree-wide?

Maybe there should be some new #defines like:

#define PCI_NAMED_DEVICE(vendor, device) \
	PCI_DEVICE(PCI_VENDOR_ID_##vendor, PCI_DEVICE_ID_##vendor##_##device)

#define PCI_UNNAMED_DEVICE(vendor, device) \
	PCI_DEVICE(PCI_VENDOR_ID_##vendor, device)


