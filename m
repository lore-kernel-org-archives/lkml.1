Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbZLVS4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbZLVS4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 13:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbZLVS4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 13:56:35 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:60194 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbZLVS4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 13:56:35 -0500
MIME-Version: 1.0
In-Reply-To: <ac3eb2510912220857g752a8d5ek20a37a79f053fb58@mail.gmail.com>
References: <20091211212642.GA6624@kroah.com>
	 <1260570289-6997-4-git-send-email-gregkh@suse.de>
	 <cc557aab0912210537pdc076e7p5c90303fb6a32b66@mail.gmail.com>
	 <ac3eb2510912210637n629ec609vf838a8b572867ffa@mail.gmail.com>
	 <cc557aab0912220610w7c3c57aaq3b6d96f6eb7085ca@mail.gmail.com>
	 <ac3eb2510912220857g752a8d5ek20a37a79f053fb58@mail.gmail.com>
Date: Tue, 22 Dec 2009 20:56:26 +0200
Message-ID: <cc557aab0912221056o534beb03r8ce0a98d8aaa1e36@mail.gmail.com>
Subject: Re: [PATCH 04/27] Driver core: devtmpfs: prevent concurrent 
	subdirectory creation and removal
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 6:57 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Tue, Dec 22, 2009 at 15:10, Kirill A. Shutemov <kirill@shutemov.name> wrote:
>> On Mon, Dec 21, 2009 at 4:37 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>>> On Mon, Dec 21, 2009 at 14:37, Kirill A. Shutemov <kirill@shutemov.name> wrote:
>>>> v2.6.33-rc1-96-gdd59f6c:
>>>> I guess it can be related to this commit.
>>>
>>> The fix is already pending here:
>>>  http://patchwork.kernel.org/patch/68337/
>>
>> One more problem: you don't unlock dirlock if kstrdup() failed.
>
> Oh right, will send a fix tomorrow.

Reported-by Kirill A. Shutemov <kirill@shutemov.name>
