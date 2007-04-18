Return-Path: <linux-kernel-owner+w=401wt.eu-S932796AbXDRHVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbXDRHVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 03:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932778AbXDRHVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 03:21:23 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1707 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768AbXDRHVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 03:21:22 -0400
Message-ID: <19259.213.222.28.155.1176880873.squirrel@webmail.xs4all.nl>
In-Reply-To: <1176846917.5946.79.camel@localhost.localdomain>
References: <20070416213350.GB4030@suse.de>
    <Line.LNX.4.64.0704161846110.13905@d.namei>
    <1176846917.5946.79.camel@localhost.localdomain>
Date: Wed, 18 Apr 2007 09:21:13 +0200 (CEST)
Subject: Re: AppArmor FAQ
From: "Rob Meijer" <capibara@xs4all.nl>
To: "Karl MacMillan" <kmacmill@redhat.com>
Cc: "James Morris" <jmorris@namei.org>, "John Johansen" <jjohansen@suse.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Reply-To: capibara@xs4all.nl
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, April 17, 2007 23:55, Karl MacMillan wrote:
> On Mon, 2007-04-16 at 20:20 -0400, James Morris wrote:
>> On Mon, 16 Apr 2007, John Johansen wrote:
>>
>> > Label-based security (exemplified by SELinux, and its predecessors in
>> > MLS systems) attaches security policy to the data. As the data flows
>> > through the system, the label sticks to the data, and so security
>> > policy with respect to this data stays intact. This is a good approach
>> > for ensuring secrecy, the kind of problem that intelligence agencies
>> have.
>>
>> Labels are also a good approach for ensuring integrity, which is one of
>> the most fundamental aspects of the security model implemented by
>> SELinux.
>>
>> Some may infer otherwise from your document.
>>
>
> Not only that, the implication that secrecy is only useful to
> intelligence agencies is pretty funny. Personally, I think that
> protecting the confidentiality of my data is important (and my bank and
> health care providers protecting the data they have about me). Type
> Enforcement was specifically designed to be able to address integrity
> _and_ confidentiality in a way acceptable to commercial organizations.
>
> Karl

Shouldn't that be _OR_, as I have always understood confidentialy
models like BLP are by their very nature incompatible with integrity
models like Biba. Given this incompatibity, I think the idea that
BLP style use of lables (ss/* property and the likes) is only usefull
to intelligence agencies may well be correct, while usage for integrity
models like Biba and CW would be much broader than that.

A path based 'least priviledge' (POLP) solution would I think on its own
address neither integity nor confidentiality, and next to this would
proof to be yet an other 'fat profile' administration hell.

Having said that, I feel a path based solution could have great potential
if it could be used in conjunction with the object capability model, that
I would consider a simple and practical alternative integrity model that
does not require lables in an MLS maner, and that extends on the POLP
concept in a way that would be largely more practical.
That is, using 'thin' path based profiles would become very practical if
all further authority can be communicated using handles in the same way
that an open file handle can be communicated.

Rob

