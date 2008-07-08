Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYGHVVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYGHVVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 17:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbYGHVVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 17:21:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47547 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbYGHVVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 17:21:17 -0400
Message-ID: <4873DA2A.5040200@zytor.com>
Date: Tue, 08 Jul 2008 17:20:42 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: "J.H." <warthog19@eaglescrag.net>, Jan Engelhardt <jengelh@medozas.de>,
       webmaster@kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>,
       hpa@kernel.org
Subject: Re: git pull through http / git
References: <48724130.5050501@atmel.com>	 <alpine.LNX.1.10.0807071840470.8248@fbirervta.pbzchgretzou.qr>	 <487315A3.40302@atmel.com> <1215502472.1998.25.camel@localhost.localdomain> <4873794F.8010508@atmel.com>
In-Reply-To: <4873794F.8010508@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre wrote:
> J.H. :
>> Keep in mind Kernel.org uses caching on gitweb and thus gitweb itself is
>> not necessarily accurate / up to date.  git.kernel.org also round-robins
>> across 4 machines which may be in various states of update, so your
>> fundamentally looking at a number of different possible points that may
>> be slightly out of sync with each other.
> 
> Ok, I understand.
> I am talking about a 3 days old commit. Is this normal to have no update 
>  from the http side ?
> I yes, I will wait...
> 

You're trying to do a git pull via http (as opposed to gitweb)?  Then 
that is dependent on the owner of the repository having enabled
"git update-server-info".

Overall, avoid pulling git via http.  It's just plain broken.

	-hpa
