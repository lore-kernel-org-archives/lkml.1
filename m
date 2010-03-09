Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab0CIPnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 10:43:16 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:40768 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab0CIPnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 10:43:13 -0500
In-Reply-To: <4B959F3C.3020701@seas.upenn.edu>
References: <1268082827-2680-1-git-send-email-micki@n-trig.com>  <1268082827-2680-2-git-send-email-micki@n-trig.com> <4B959F3C.3020701@seas.upenn.edu>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <AC7EBCFD-B650-4B58-B12A-13D20F56E7FF@enac.fr>
Cc: mickib1@gmail.com, Jiri Kosina <jkosina@suse.cz>, peterhuewe@gmx.de,
       Micki Balanga <micki@n-trig.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH 2/7] HID: N-trig MTM Driver fix and cleanup patch 2
Date: Tue, 9 Mar 2010 16:43:08 +0100
To: Rafi Rubin <rafi@seas.upenn.edu>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 9 mars 10 à 02:07, Rafi Rubin a écrit :
>
>>   		case HID_DG_HEIGHT:
>>   			hid_map_usage(hi, usage, bit, max,
>>   					EV_ABS, ABS_MT_TOUCH_MINOR);
>> -			input_set_abs_params(hi->input, ABS_MT_ORIENTATION,
>> -					0, 1, 0, 0);
>
> Stephane added the orientation to height, I can't comment about the  
> wisdom of pulling it.

The MT kernel protocol says that width/height is reported through  
TouchMinor/TouchMajor/Orientation. Orientation needs to be added  
somewhere. Doing it when encountering width or height seemed a  
logical thing to do, but I would see no objection at doing it  
somewhere else with TouchMinor and TouchMajor.

Cheers,

St.

