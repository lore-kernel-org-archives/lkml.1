Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbYLYXGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbYLYXGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 18:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYLYXGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 18:06:42 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:10574 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbYLYXGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 18:06:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from;
        b=tYe1QtGLA4Or96IQ89pB3oPSuv2rIK3mU0l2+vd2svwA8MGbdqZgAKPnUisye4+3FZ
         xyBoUj/fOP74yEM8230c3rL7j3/ADcLlTVmI5jKN1AI19Jtiv/fRjADLNpRt5tnIMBHS
         pqofZXPLKMgYLvQ1OXVXq3huLt/BQkbuizDWU=
Message-ID: <495411FD.60409@gmail.com>
Date: Thu, 25 Dec 2008 18:06:37 -0500
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Michael Roth <mroth@nessie.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Funny problem with 2.6.28: Kernel stalls
References: <4953A35C.8090005@nessie.de>
In-Reply-To: <4953A35C.8090005@nessie.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
From: Andrew Drake <zappacky.lists@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Roth wrote:
> 
> The funny part: If I hit any key (on the keyboard connected by USB) the
> kernel resumes to normal work until the next stall.
> 

This sounds a little bit like my old problem... try kernel option nolapic_timer.
It worked for me, perhaps it can do the same for you.

- Andrew
