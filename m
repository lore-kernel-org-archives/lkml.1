Return-Path: <linux-kernel-owner+w=401wt.eu-S1751242AbZKKIjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242AbZKKIjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 03:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbZKKIjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 03:39:39 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:45209 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbZKKIji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 03:39:38 -0500
Message-ID: <4AFA784D.1060001@natemccallum.com>
Date: Wed, 11 Nov 2009 03:39:41 -0500
From: Nathaniel McCallum <nathaniel@natemccallum.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Devices that ignore USB spec generate invalid modaliases
References: <4AFA73C7.4070002@natemccallum.com>
In-Reply-To: <4AFA73C7.4070002@natemccallum.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 03:20 AM, Nathaniel McCallum wrote:
> Drivers for devices which have bcdDevice conforming to BCD will have no
> change in modalias output.

One small clarification. Existing drivers which specify a non-zero lower 
bound and an upper bound past the next character will have their upper 
bound changed from 0x9 to 0xf (i.e.: d123[4-9] -> d123[4-9a-f]).  I 
believe this is the only case where an existing (working) modalias will 
change.

Nathaniel McCallum

