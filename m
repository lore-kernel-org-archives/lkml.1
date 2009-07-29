Return-Path: <linux-kernel-owner+w=401wt.eu-S1751150AbZG2Rb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbZG2Rb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbZG2RbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:31:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40197 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbZG2RbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:31:24 -0400
Message-ID: <4A708745.5040203@zytor.com>
Date: Wed, 29 Jul 2009 10:30:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86, msr]: execute on the correct CPU subset
References: <1246890592-12256-1-git-send-email-borislav.petkov@amd.com> <4A526D38.7000803@zytor.com> <20090707103723.GD5668@aftab> <4A537010.3050905@zytor.com> <20090708111911.GC19315@aftab> <4A6E1222.5010709@zytor.com> <20090729164941.GA9388@aftab>
In-Reply-To: <20090729164941.GA9388@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2009 09:49 AM, Borislav Petkov wrote:
> On Mon, Jul 27, 2009 at 01:46:26PM -0700, H. Peter Anvin wrote:
>> Any reason not to use get_cpu() ... put_cpu() instead?
> 
> In case you haven't applied the one from yesterday yet, here's a better
> one which uses struct cpumask * instead of cpumask_t.
> 

Mangled patch (quoted-printable).

Furthermore, are there any users for this interface at this time?

	-hpa
