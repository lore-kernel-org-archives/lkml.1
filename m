Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830Ab0ALJCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab0ALJCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569Ab0ALJCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:02:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36706 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab0ALJCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:02:09 -0500
Date: Tue, 12 Jan 2010 09:01:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Francesco VIRLINZI <francesco.virlinzi@st.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 1/7 v2] Add a common struct clk
Message-ID: <20100112090149.GB26435@n2100.arm.linux.org.uk>
References: <1263279511.160551.332624337260.1.gpush@pororo> <4B4C376C.6080705@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4C376C.6080705@st.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 09:48:44AM +0100, Francesco VIRLINZI wrote:
> Hi Jeremy
> In November I already sent a proposal on
>  a generic linux clk framework.
> On that I would suggest:
>
>>
>> +struct clk {
>> +	const struct clk_operations *ops;
>>    
>            spinlock_t lock;
>            const char *name;
>            int id;

Name and ID are totally pointless, unless you insist on using the clk
API in the wrong way (like S3C does.)
