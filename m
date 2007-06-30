Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbXF3GPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbXF3GPH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 02:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXF3GO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 02:14:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:7647 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbXF3GOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 02:14:55 -0400
Message-ID: <fa686aa40706292314g3323c98dxdecd8b5a289f1c64@mail.gmail.com>
Date: Sat, 30 Jun 2007 02:14:55 -0400
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Akinobu Mita" <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       "Eberhard Moenkeberg" <emoenke@gwdg.de>,
       "Joe Thornber" <dm-devel@redhat.com>,
       "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/4] void unregister_blkdev - delete redundant messages
In-Reply-To: <20070630031212.GD4045@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070630031013.GC4045@APFDCB5C> <20070630031212.GD4045@APFDCB5C>
X-Google-Sender-Auth: de5ec85823b6e512
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> No need to warn unregister_blkdev() failure by the callers.
> (The previous patch makes unregister_blkdev() print error message in
> error case)

Seeing as none of the callers check the error code; why does the
function return anything at all?

g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
