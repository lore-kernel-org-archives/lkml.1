Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbYLOAL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbYLOAL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 19:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYLOALU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 19:11:20 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:42578 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751504AbYLOALT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 19:11:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JFa+dPYbbxsLdJ2EocrLaONwkFcVEpviJhDpdwK8rJFO3b225PIKTopwojclQiVpwqqpIP+V966ot2Dldzd3kWkGS/wUV0YqJibnqR+P3JmniERPADxZtu3PdAb4ijxVb/1T5u8eTtvEjT6ojEhBCSgrO9YEVdR149GSC0dwB+4=  ;
X-YMail-OSG: GkvqoJAVM1nt4ikusZ7bLqZco8ow_uWW49KrSrCv3je2XVLJZ_x244gDL87uVyMbOb_IEgGKmpEoItDQUGUgtpO0BhVKrI8xEEFyM_U.wJB4gJ5LxrZh3s1c66aLCj63ycVxEHoxEAk_y7IzZqyk4lm3NVKbeiOt8WaGa2KLF3SyDRVHtXBL94rzaeHv
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Dooks <ben-linux@fluff.org>
Subject: Re: GPIO: Fix probe() error return in gpio driver probes
Date: Sun, 14 Dec 2008 16:11:17 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
References: <20081212152426.745254309@fluff.org.uk> <20081214213349.GA19483@fluff.org.uk>
In-Reply-To: <20081214213349.GA19483@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812141611.17555.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 December 2008, Ben Dooks wrote:
> Has anyone reveiwed this patch? Are there any comments, or can this
> be commited at somepoint (even if it is during the next merge window)?

I was thinking that -EINVAL is almost the least informative
diagnostic code possible, since so many places return it
that it's usually hard to find out *which* invalid parameter
triggered ...

Is there a less-overloaded code you could return?

I have no issue with the patch other than that.

- Dave
