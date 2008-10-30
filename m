Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbYJ3XQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbYJ3XQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYJ3XQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:16:05 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:64207 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYJ3XQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:16:03 -0400
Message-ID: <ac3eb2510810301616n271102fcred30bc1eef6a8dba@mail.gmail.com>
Date: Fri, 31 Oct 2008 00:16:01 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: hid: struct device - replace bus_id with dev_name(), dev_set_name()
Cc: "Jiri Slaby" <jirislaby@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>
In-Reply-To: <alpine.LNX.1.10.0810310009110.31273@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225385705.21973.20.camel@nga.site> <490A0A35.9060606@gmail.com>
	 <1225395316.21973.47.camel@nga.site>
	 <alpine.LNX.1.10.0810310009110.31273@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 00:10, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 30 Oct 2008, Kay Sievers wrote:
>
>> > > switch over to the new api, which will remove the 20 bytes array
>> > > and does no longer have a size limitation.
>> > Cool!
>> > Could you left the comment above to remind us about removing this ugly hack
>> > later when the new non-limited api will be used?
>> Sure!
>> From: Kay Sievers <kay.sievers@vrfy.org>
>> Subject: hid: struct device - replace bus_id with dev_name(), dev_set_name()
>
> Hi Kay,
>
> thanks for this cleanup. What is the timeframe the bus_id will be removed
> from struct device?

Hmm, not sure. We will put the remaining pieces into Greg's tree, wait
for -next to carry most of it, and convert the rest. Maybe we can do
it for the next kernel, but we might get sidetracked again, and it
might take longer.

Thanks,
Kay
