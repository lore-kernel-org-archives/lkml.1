Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYKUHV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYKUHV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 02:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYKUHVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 02:21:17 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:52818 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbYKUHVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 02:21:16 -0500
Message-ID: <49266175.9090403@suse.de>
Date: Fri, 21 Nov 2008 12:51:25 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Steve French <smfrench@gmail.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [linux-cifs-client] Re: third patch
References: <20081114185039.1f3af842@tleilax.poochiereds.net>	<524f69650811141609n63f3631bn6493e2be76b1bed6@mail.gmail.com>	<20081115063641.26003498@tleilax.poochiereds.net>	<524f69650811161918i738ba50frd87666a58640b76f@mail.gmail.com>	<20081117055603.GA1381@kroah.com>	<524f69650811171506y1f518c3bnac03e4f557ba29fb@mail.gmail.com> <20081117233833.GA28435@kroah.com>
In-Reply-To: <20081117233833.GA28435@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Nov 17, 2008 at 05:06:43PM -0600, Steve French wrote:
>> On Sun, Nov 16, 2008 at 11:56 PM, Greg KH <greg@kroah.com> wrote:
>>> On Sun, Nov 16, 2008 at 09:18:43PM -0600, Steve French wrote:
>>>> Jeff and I have worked on a series of patches to fix the oopses,
>>>> memory corruption and mount failures due to races in various linked
>>>> list handling relating to socket, session and tree connection when
>>>> using the reproducer detailed here:
>>
>> I don't mind the large mount/umount fix series (diffstat shows about
>> 800 lines added, 800 removed) being included in stable, it does fix
>> some oopses that can occur with simultaneous cifs mounts/umounts
>> racing.
> 
> Well, if Linus takes them so late in the merge window, I'll consider
> also adding them to -stable, as they do fix reported problems, and are
> good to have in there for users who rely on cifs.
> 

I have backported this patchset for 2.6.27.7 along with cifs data
corruption fixes and would be sending it to stable@kernel.org requesting
for inclusion since these had been merged upstream and fixes various
critical problems.


Thanks,

-- 
Suresh Jayaraman

