Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbZKZRLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbZKZRLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760706AbZKZRLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:11:42 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42543 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760546AbZKZRLl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:11:41 -0500
MIME-Version: 1.0
In-Reply-To: <661de9470911260903h4996070emec678f09a7ba2c9e@mail.gmail.com>
References: <bc4dc055a7307c8667da85a4d4d9d5d189af27d5.1259248846.git.kirill@shutemov.name>
	 <cover.1259248846.git.kirill@shutemov.name>
	 <8524ba285f6dd59cda939c28da523f344cdab3da.1259248846.git.kirill@shutemov.name>
	 <d977350fcc9bc3e1fe484440c1fc3a7470a4e26b.1259248846.git.kirill@shutemov.name>
	 <661de9470911260903h4996070emec678f09a7ba2c9e@mail.gmail.com>
Date: Thu, 26 Nov 2009 19:11:46 +0200
Message-ID: <cc557aab0911260911y577e203aha1c74a7f0f361226@mail.gmail.com>
Subject: Re: [PATCH RFC v0 3/3] memcg: implement memory thresholds
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 7:03 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> On Thu, Nov 26, 2009 at 9:57 PM, Kirill A. Shutemov
> <kirill@shutemov.name> wrote:
>> It allows to register multiple memory thresholds and gets notifications
>> when it crosses.
>>
>> To register a threshold application need:
>> - create an eventfd;
>> - open file memory.usage_in_bytes of a cgroup
>> - write string "<event_fd> <memory.usage_in_bytes> <threshold>" to
>>  cgroup.event_control.
>>
>> Application will be notified through eventfd when memory usage crosses
>> threshold in any direction.
>>
>> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
>>
>
> I don't see the patches attached or inlined in the emails that follow

Sorry. Resent.
