Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbYKPImT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbYKPImT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 03:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYKPImM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 03:42:12 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:16482 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbYKPImK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 03:42:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TSlWQfd2p94r90hIP3ztFMiZr0Hjg6lxe3n8oj7TnC9YTmxkRkFlWRSOAd4Nr3ZYku
         hA5DzhuUYuDKYDxeR5KayP9/DxLxZIzaI9x29wMvseni409NRlyvkV4PcIio4VZAZuY4
         Cm9EwJkbH93zzyWqHfDr7wB/lFvek03nAg+2U=
Message-ID: <2f3bf9a60811160042h77ab2a5dh1bd479dc9707f682@mail.gmail.com>
Date: Sun, 16 Nov 2008 10:42:09 +0200
From: "Dotan Barak" <dotanba@gmail.com>
To: apw@uk.ibm.com
Subject: False positive in checkpatch on pointers to typedefs?
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Executing checkpatch version 0.24 of the following c program produces
the following error message:

ERROR: need consistent spacing around '*' (ctx:WxV)
#7: FILE: dotan.c:7:
+       my_int *time_arr[SIZE];


<code start>
#define SIZE 10

typedef int my_int;

int main()
{
        my_int *time_arr[SIZE];

        return 0;
}
<code end>


I can't find anything wrong in this C code.

Can you please check this issue?

Thanks
Dotan
