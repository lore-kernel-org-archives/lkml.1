Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYJMRMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYJMRMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 13:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbYJMRMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 13:12:41 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37082 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304AbYJMRMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 13:12:39 -0400
Subject: Re: [PATCH]IB/ehca:reject dynamic memory add/remove
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>, general@lists.openfabrics.org,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, hnguyen@de.ibm.com
In-Reply-To: <200810131310.34413.ossrosch@linux.vnet.ibm.com>
References: <200810131310.34413.ossrosch@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 10:09:26 -0700
Message-Id: <1223917766.29877.17.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-13 at 13:10 +0200, Stefan Roscher wrote:
> Since the ehca device driver does not support dynamic memory add and remove
> operations, the driver must explicitly reject such requests in order to prevent
> unpredictable behaviors related to memory regions already occupied and being
> used by InfiniBand applications.
> The solution is to add a memory notifier to the ehca device driver and if a request
> for dynamic memory add or remove comes in, ehca will always reject it.

Why doesn't the driver support it?

This seems like an awfully extreme action to take.  Do you have plans to
support this in the driver soon?

-- Dave

