Return-Path: <linux-kernel-owner+w=401wt.eu-S965587AbXCVBjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965587AbXCVBjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 21:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965580AbXCVBjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 21:39:42 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:35631 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965587AbXCVBjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 21:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=liIyxYXkd7qnOXhQGnCSdP4HBcW/jV8rQS0NWHj+8shUY9uC4yG/JsOX0wY+cpQH8ltFv0hjWwVBEE3l2WnEOTeFrmHtmGFKFCeI0DdKkOsf+9DBhy9DArYMi+lNwoTfA4q7a1VzGRBoHmhu6qrHmpPjvGwRfKvHfMNKU5ANNXQ=
Message-ID: <2fe399760703211839v4426599asf648bf5cb7d58f82@mail.gmail.com>
Date: Wed, 21 Mar 2007 18:39:40 -0700
From: "Phy Prabab" <phyprabab@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: mmap and swap
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a mysterious issue with swapping.  I have a 32b machine running
2.4.21.x (RHEE30) w/4G RAM and 8G swap.  If I run one application and
pause it after having allocated 2.5G and then run another application
(or just another instance of the same app) and try to allocate another
2.5G I would have imagined that the first would be swapped out.  But
this is not the case, rather, only part of the first application is
swapped before allocation for the second application fails trying to
allocate more space.  What is even more interesting is that the first
application seems to only swap out memory allocated via sbrk.   So
within this application I allocate memory via sbrk until failure
(~890M) and then switch to mmap.  The glibc version is 2.3.2 and I am
mmaping memory via private|anonymous, so am I doing something
incorrect or is that mmap can not be swapped out?

TIA,
Phy
