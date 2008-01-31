Return-Path: <linux-kernel-owner+w=401wt.eu-S1764702AbYAaPU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764702AbYAaPU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbYAaPUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:20:48 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:33117 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756265AbYAaPUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:20:47 -0500
Message-ID: <47A1E734.507@nortel.com>
Date: Thu, 31 Jan 2008 09:20:20 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Adrian Bunk <bunk@kernel.org>, Giridhar Pemmasani <pgiri@yahoo.com>,
       Pavel Roskin <proski@gnu.org>, linux-kernel@vger.kernel.org,
       Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>, rms@gnu.org
Subject: Re: ndiswrapper and GPL-only symbols redux
References: <20080129225701.GS8767@does.not.exist> <754585.89171.qm@web32403.mail.mud.yahoo.com> <20080130175447.GB29368@does.not.exist> <47A13FBD.9080709@davidnewall.com>
In-Reply-To: <47A13FBD.9080709@davidnewall.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jan 2008 15:20:24.0526 (UTC) FILETIME=[CD3D2EE0:01C8641C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> This idea that some symbols may only be
> dynamically bound to GPL code is fallacy.

As I understand it, the point of EXPORT_SYMBOL_GPL is not so much the 
technical restriction (as you say, the module can lie or the user can 
patch the kernel) but to indicate that the kernel developers consider 
such interfaces to be internal to the kernel such that anything using it 
would be highly likely to be a "derived work" of the kernel.

It's a hint to other developers rather than a prevention measure.

Chris
