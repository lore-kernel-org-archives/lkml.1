Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYGQNeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYGQNeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 09:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbYGQNeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 09:34:12 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:31461 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbYGQNeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 09:34:11 -0400
Message-ID: <1b7401870807170634u14492a53k3931ddcddbd1e098@mail.gmail.com>
Date: Thu, 17 Jul 2008 09:34:10 -0400
From: "Josef Bacik" <josef@toxicpanda.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer dereference at 0000000c
Cc: linux-ext4@vger.kernel.org, sct@redhat.com, akpm@linux-foundation.org,
       adilger@sun.com, "Johannes Weiner" <hannes@saeurebad.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807170620g39ab942bl592ea3fa3fa0dab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807170551q4fbb862bu270297cfd76a69be@mail.gmail.com>
	 <1b7401870807170613y747baa7by158177047cc7e28@mail.gmail.com>
	 <19f34abd0807170620g39ab942bl592ea3fa3fa0dab@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 9:20 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Thu, Jul 17, 2008 at 3:13 PM, Josef Bacik <josef@toxicpanda.com> wrote:
>> On Thu, Jul 17, 2008 at 8:51 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>> Hi,
>>>
>>> I get this with both clean v2.6.26 and latest -git
>>> (33af79d12e0fa25545d49e86afc67ea8ad5f2f40):
>>>
>>
>> Thanks for the report, do you happen to have any messages above the
>> panic message that would indicate if there was some sort of fs error
>> that was hit before the panic?  That would help me figure out what
>> exactly happened.  Thanks,
>
> Yeah, the full log exists at
>
>    http://folk.uio.no/vegardno/linux/log-1216293934.txt
>
> I think this is the interesting part:

Hmm well the journal should have aborted, but it looks like it didn't,
are you mounting with errors=continue by any chance?  Thanks much,

Josef
