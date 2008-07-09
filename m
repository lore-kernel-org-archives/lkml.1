Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbYGIPmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbYGIPmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYGIPme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:42:34 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:24412 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbYGIPmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:42:33 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: Martin Knoblauch <knobi@knobisoft.de>, Pavel Machek <pavel@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Date: Wed, 9 Jul 2008 15:41:41 +0000
Subject: RE: [PATCH][resubmit] HP iLO driver
Thread-Topic: [PATCH][resubmit] HP iLO driver
Thread-Index: Acjh1pdiE+Yq/YQ3Q+2Oy0nHEIAnzwAAg2zQ
Message-ID: <CF70AA892F109448AEA269483B3A983903BBB04814@G1W1215.americas.hpqcorp.net>
References: <19533.95591.qm@web32604.mail.mud.yahoo.com>
In-Reply-To: <19533.95591.qm@web32604.mail.mud.yahoo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Knoblauch wrote:
>
>  hponcfg - configuration
>  hpdiags - ???
>  hp-snmp-agents - ??? Do they provide sensor information?
>  iLO Flash - Firmware upgrade

hpdiags and hp-snmp-agents both use this driver to gather basic
management processor info, stuff like MP NIC config and stats,
serial number, etc (but no sensors).

>
>  OK, so this is really Proliant and likely Blades only? No
> chance that this will show up elsewhere?
>
I know of no plans to use this elsewhere.

>> Yeah, those are most common.  This driver will also surface data
>> through HPSMH or HPSIM, if the proper packages are installed.
>>
>
>  Hmm. I am a bit out of touch. What are they doing?

HPSMH is "System Management Homepage", and SIM is
"Systems Insight Manager".  They both are web based management
consoles, and show the info gathered by hp-snmp-agents and hpdiags,
along with lots of other system info.

>
>  I really believe that if the HP-ILO driver is only needed
> for configuration and FW upgrades, it is OK in the current
> state. I do not think that anybody really wants to write
> another hponcfg or iLO-flash.

That is true.  Even if there was a management processor framework,
I would still want a simple read/write interface, to support
our existing software.

>  But if it is also needed to obtain sensor information, your
> colleagues should really think about supporting the
> lm_sensors framework.

It isn't needed/used for sensor info.
