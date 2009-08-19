Return-Path: <linux-kernel-owner+w=401wt.eu-S1751337AbZHSG2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbZHSG2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 02:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbZHSG2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 02:28:43 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:13043 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbZHSG2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 02:28:42 -0400
Message-Id: <4A8BB7B802000078000107DC@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 19 Aug 2009 07:28:40 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Robert Richter" <robert.richter@amd.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] i386: fix section mismatches for init code
	 with!HOTPLUG_CPU
References: <4A8AE7CD020000780001054B@vpn.id2.novell.com>
 <20090818175740.GV9915@erda.amd.com>
In-Reply-To: <20090818175740.GV9915@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Robert Richter <robert.richter@amd.com> 18.08.09 19:57 >>>
>On 18.08.09 16:41:33, Jan Beulich wrote:
>> Commit 0e83815be719d3391bf5ea24b7fe696c07dbd417 changed the section the
>> initial_code variable gets allocated in, in an attempt to address a
>> section conflict warning. This, however created a new section conflict
>> when building without HOTPLUG_CPU. The apparently only (reasonable) way
>> to address this is to always use __REFDATA.
>
>Hmm, not sure if I am missing something, but my patch actually
>shouldn't have changed the !HOTPLUG_CPU case:

Correct, but it also didn't take care of it, despite changing the code in
question.

Jan

