Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbYKKPhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbYKKPhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 10:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYKKPhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 10:37:37 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:14491 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbYKKPhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 10:37:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Dh92ASDAPEquQuv+9SBMGIibvYfIMz1Q3tLWpPkxG2EmqUdd4NaN3leRUvZjXgWNae
         F4yDEeYng+N6vGhKfStYCfszb0nR34mnvldmDVdBeMxtxBFfoet+GRedf10lqpOfEzMf
         Fp9wbzM8kC6sWEDLrgVxVxCxzbug0CwWy2Xn8=
Message-ID: <e9c3a7c20811110737m4b17e0fcp45bcec86f937b9ea@mail.gmail.com>
Date: Tue, 11 Nov 2008 08:37:35 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/4 v1] i.MX31: Image Processing Unit DMA and IRQ drivers
Cc: linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
In-Reply-To: <Pine.LNX.4.64.0811111029120.4565@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0811071454000.4513@axis700.grange>
	 <Pine.LNX.4.64.0811071512500.4513@axis700.grange>
	 <Pine.LNX.4.64.0811111029120.4565@axis700.grange>
X-Google-Sender-Auth: 706bdc68205a5762
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 2:36 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> I still have no solution to this ->client_count problem. Is this a bug and
> there should be a way to release a channel (including decrementint the
> client_count) without unregistering the client, or am I missing something?
>

Hi Guennadi,

I am currently working on improving this situation:

http://marc.info/?l=linux-kernel&m=122463374500746&w=2

Please have a look.

Thanks,
Dan
