Return-Path: <linux-kernel-owner+w=401wt.eu-S1760326AbYELJXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760326AbYELJXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 05:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757058AbYELJXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 05:23:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:48374 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350AbYELJXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 05:23:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oqWqEPz8jbRsVTOnOR406WX89FU6pAY4vdQnsjK8eJ92bRjvNdtqurlgWwavocW3VzwkyQk8KqydwrOTkgeVHkp4cvggOEdDD055Cma4idlF4XwzuFmHqw1ew4Z9Rar1uRukaFNuhM3rZHAxEyjK3wplxRldtJMy8Ivh74dtyfg=
Message-ID: <1ba2fa240805120223m2ff24028j5f5f29a0e40153e2@mail.gmail.com>
Date: Mon, 12 May 2008 12:23:34 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Mirco Tischler" <mt-ml@gmx.de>
Subject: Re: BUG: scheduling while atomic: events/1/10/0x00000002 on linux-next
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Reinette Chatre" <reinette.chatre@intel.com>,
       "Zhu Yi" <yi.zhu@intel.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Emmanuel Grumbach" <egrumbach@gmail.com>
In-Reply-To: <1210534778.5052.3.camel@mtlp.tischlernetz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210524139.17521.5.camel@mtlp.tischlernetz>
	 <1ba2fa240805111226s6f900015n4144f5411957ef2a@mail.gmail.com>
	 <1210534778.5052.3.camel@mtlp.tischlernetz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 10:39 PM, Mirco Tischler <mt-ml@gmx.de> wrote:
>> What exact git tree is this?
>>   iwlcore:iwl_send_cmd_sync+0x154/0x24b waits for event so something
>> has changed in mac80211. Need to see the code.
>>
>> Thanks
>> Tomas
>>
> This is Stephen's linux-next tree from 2008-05-09. Checkout tag
> next-20080509.

Reproduced, we will release patch into wireless-testing.git

Thanks for reporting
Tomas
