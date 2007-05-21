Return-Path: <linux-kernel-owner+w=401wt.eu-S1763687AbXEUPSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763687AbXEUPSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758913AbXEUPSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:18:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:53073 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbXEUPSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:18:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=OYQ3tMCfesVPtvQyzpWxy3S676ccChneLAciKuuYFeo8dCKqgSfWYUyK0PdjORZy0p2GEe5ZP0tVYouCtFswlYd/goApvq7oB5RB0lUYCB5mVZBnu3HGlkzH9RyARmkzPVTzGgt3WmYLzdHgl/oPWD3yfTE8h6xI5+u1ZbNAuIs=
Message-ID: <4651B834.3060702@gmail.com>
Date: Mon, 21 May 2007 17:18:12 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Robert de Rooy <robert.de.rooy@gmail.com>
CC: linux-kernel@vger.kernel.org, alan@redhat.com, bzolnier@gmail.com,
       jgarzik@pobox.com
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com> <464C1575.8070005@gmail.com> <464CB7C9.2080807@gmail.com> <46503192.1040300@gmail.com> <4650B9E3.7070409@gmail.com> <46518798.2020808@gmail.com> <4651B66E.6030505@gmail.com>
In-Reply-To: <4651B66E.6030505@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert de Rooy wrote:
> This gets a little bit further again, but now I get lots of new errors....

Alright, this doesn't seem to be the CF reader's problem anymore.  It
seems the PCMCIA controller isn't passing interrupts properly.  Does any
other device work in the slot?

-- 
tejun
