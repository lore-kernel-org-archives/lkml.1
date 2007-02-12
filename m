Return-Path: <linux-kernel-owner+w=401wt.eu-S1030215AbXBLW2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030215AbXBLW2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030213AbXBLW2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:28:08 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:27744 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030215AbXBLW2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:28:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XBJGr17nX9eastvIr9ti+OLdiXVKPQ+43BBk1cm2CzSTUlUUbbf875wqGfpp3kurDa8l9E+CnoaH+rbsMTeomtHOtfqTIh2wUVGjiLWtOy6i7K6Rp5gu1DlT2Mz9tG09KRoN2dvv+awlpBqt6h135hoJVie56z6TJuJ/Y6TYtRk=
Message-ID: <8d158e1f0702121428i4bcd350ane19642e2d90c29ee@mail.gmail.com>
Date: Mon, 12 Feb 2007 23:28:03 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] Which dependency am I missing?
In-Reply-To: <8d158e1f0702121341sf387cbfl8d904d054e1f4b1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702121341sf387cbfl8d904d054e1f4b1f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/07, Patrick Ale <patrick.ale@gmail.com> wrote:
> Hi folks,

Disregard, I found the problem.
CONFIG_NEW_LED=Y , so I have to do a make and boot from the produced image.

Which brings me to another question.
If a dependent driver is selected as module (for reasons you dont want
to reboot and all), is it possible to have the dependencies built as
module aswell rather than being built into the kernel? for
CONFIG_NEW_LED I cant choose for built-in or module, it's built-in,
and that's all there is possible.


Patrick
