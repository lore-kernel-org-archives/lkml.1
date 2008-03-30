Return-Path: <linux-kernel-owner+w=401wt.eu-S1751610AbYC3EcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbYC3EcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 00:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbYC3Eb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 00:31:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34092 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750905AbYC3Eb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 00:31:59 -0400
Date: Sat, 29 Mar 2008 23:31:55 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86_64 boot -v2: Add linked list of struct
 setup_data
Message-Id: <20080329233155.ee909a04.pj@sgi.com>
In-Reply-To: <1206672584.13404.25.camel@caritas-dev.intel.com>
References: <1206672584.13404.25.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang wrote:
> +/* setup data types */
> +#define SETUP_NONE			0

This define seems unused?

Actually, what use would it ever have?  Should not every
struct setup_data on the setup_data linked list have a
valid (not NONE) type?  And perhaps that switch statement
that confused me:

> +		switch (data->type) {
> +		default:
> +			break;
> +		}

should not "break" silently on an unrecognized data->type, but
rather complain bitterly?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
