Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbYDPTxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbYDPTxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYDPTxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:53:00 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:31574 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbYDPTw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:52:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=aWGRSaLW2HZVNRFVnKMsaa1zA3rGa4DQePxaF6uLKhkf4UoFV2GmmXd5ypwRs872tX0aYhlsHgbrc9zIKWhb0PHGPmz3UhMtYAUupJS+rzBfQQpplKnqvCQiIncEpd77dZnW9IqClHHg/Xm6+UtQ4SXRonF92pvGilTsp9fvrpw=
Message-ID: <4806583B.5080305@gmail.com>
Date: Wed, 16 Apr 2008 21:49:15 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 and DEBUG_SECTION_MISMATCH
References: <20080416175135.GN1677@cs181133002.pp.htv.fi> <20080416192306.GA3090@uranus.ravnborg.org> <20080416193102.GA16981@elte.hu>
In-Reply-To: <20080416193102.GA16981@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar pisze:
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
>> I would prefer we were down to less than 5 warnings so we could enable 
>> it in kconfig but maybe after next merge window.
> 
> they get regenerated. More than 1 out of every 100 new patches. Quite 
> expensive feature (in terms of maintenance overhead) for a rather 
> theoretical memory saving benefit.

Ok, that's why this should be done in places where we are sure that given
function is called once and none should call more. So in general this should
result in removing few(?) annotations not in adding it everywhere where mismatch
appears.

-Jacek
