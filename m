Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbYGWWCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbYGWWCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbYGWWCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:02:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:40562 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYGWWCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:02:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pwAV7Vf3EywaGAK738C+Qs8xUK7huTaiuZBU1NY+t7c2E+jvulc2KusSAVQPBFqrxi
         e2oKio1l8UYwhM3BtFB1nUClCnz0z03eUX6JeyuHpZaz4Je6/Z2IvwjRCJ5+FMWYyQwh
         LXgZZwopfzddPjqgF9K361q9bQrhOam42NY6k=
Message-ID: <1ba2fa240807231502t1c4ce7d5k9b8acbcaed4d166a@mail.gmail.com>
Date: Thu, 24 Jul 2008 01:02:15 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, yi.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Potential iwlwifi locking problem in 2.6.26-git9
In-Reply-To: <20080723214938.GA8034@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1KLm0c-0002O6-RO@closure.thunk.org>
	 <20080723214938.GA8034@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 12:49 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Jul 23, 2008 at 05:36:30PM -0400, Theodore Ts'o wrote:
>>
>> Is this a new one?  I don't think I've seen this on LKML....
>
> The context of this was I had just booted to 2.6.26-git9, noted with
> annoyance that that the iwl4965 driver needed a new microcode file, so
> I popped in my EVDO card, downloaded the firmware, moved the firmware
> into place, and then got the above error message.
>
> I've since noted that it seems to be utterly refusing to associate
> with my wireless access point.  This was working just fine with
> 2.6.26-git6 kernel, so it looks like a recent regression?  I just
> noticed someone else had recently complained about a similar "refusal
> to associate" with the iwl3945 driver.

I'm not sure but this can be connected to what is described in thread:
'New: dhcp doesn't work with iwl4965'
Tomas
