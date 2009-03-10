Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbZCJSW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbZCJSW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbZCJSWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:22:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:41941 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbZCJSWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:22:19 -0400
MIME-Version: 1.0
In-Reply-To: <1236708806.6339.4.camel@quest>
References: <cover.1236702228.git.scott@canonical.com>
	 <20090310184624.4e28d18e@hyperion.delvare>
	 <1236707391.6339.3.camel@quest>
	 <20090310185558.072e6fc6@hyperion.delvare>
	 <1236708806.6339.4.camel@quest>
Date: Tue, 10 Mar 2009 19:22:16 +0100
Message-ID: <ac3eb2510903101122h2ff348e8waa3aee20867892fb@mail.gmail.com>
Subject: Re: [PATCH 00/31] Add a lot of module alias statements
From: Kay Sievers <kay.sievers@vrfy.org>
To: Scott James Remnant <scott@canonical.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 19:13, Scott James Remnant <scott@canonical.com> wrote:
> On Tue, 2009-03-10 at 18:55 +0100, Jean Delvare wrote:
>> On Tue, 10 Mar 2009 17:49:51 +0000, Scott James Remnant wrote:
>> > On Tue, 2009-03-10 at 18:46 +0100, Jean Delvare wrote:
>> >
>> > > I don't get how it could make any difference in terms of performance.
>> > > As far as I know, all the module aliases that come from the kernel are
>> > > assembled into /lib/modules/$version/modules.alias when the kernel is
>> > > installed, and that file must be processed by modprobe the exact same
>> > > way another configuration file would. Or am I missing something?
>> >
>> > With current modprobe those files are turned into a binary index that
>> > can be read and processed *much* faster.
>>
>> What would prevent the same binary index from being generated from
>> user-provided module aliases?
>>
> Why go to all that effort when adding the alias to the kernel is just a
> one-line change, and then it shows up along with all of the other
> aliases that depmod generates the existing binary index from?

The problem, with a new kernel or module, we know for forever, that we
have to run depmod, but this is not the case for depmod config files,
and not really to manage, to require a binary index update here.

But the main point is that we want to put information where it
belongs: in the module itself. Just look at the crap we ship in
/etc/modprobe* and you know that externally maintained configs for
kernel modules just don't work. :)

Thanks,
Kay
