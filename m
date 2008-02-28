Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbYB1SbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbYB1SbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 13:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYB1Saz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 13:30:55 -0500
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:42476
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750898AbYB1Say (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 13:30:54 -0500
Date: Thu, 28 Feb 2008 10:30:54 -0800
From: Phil Oester <kernel@linuxace.com>
To: Nebojsa Miljanovic <neb@alcatel-lucent.com>
Cc: linux-kernel@vger.kernel.org,
       "Kittlitz, Edward \(Ned\)" <nkittlitz@alcatel-lucent.com>,
       asweeney@alcatel-lucent.com,
       "Polhemus, William \(Bart\)" <bpolhemus@alcatel-lucent.com>
Subject: Re: SO_REUSEADDR not allowing server and client to use same port
Message-ID: <20080228183054.GA903@linuxace.com>
References: <47C6FA2A.5030302@alcatel-lucent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C6FA2A.5030302@alcatel-lucent.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 12:15:06PM -0600, Nebojsa Miljanovic wrote:
> Hello all,
> I have seen similar complaints about this issue before in the list archive, but
> I have not seen any resolution. So, I am posting the question again in hope of
> getting some replies.
> 
> Currently, Linux does not allow reuse of same local port for both TCP server and
> TCP client. I understand that there may be a need to prevent two servers from
> binding to the same local port, but having 1 server and 1 outgoing client use it
> should be allowed. Other Unix like operating systems do allow it. Further more,
> Linux SCTP socket API allows for this to happen. And, I can't imagine why this
> restriction would exists for TCP and not for SCTP.

You'd likely get better response by posting this on the netdev list.

Phil
